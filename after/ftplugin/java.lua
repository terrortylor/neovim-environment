local home = vim.fn.getenv("HOME")
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local mason_jdtls_dir = "/.local/share/nvim/mason/packages/jdtls"
local plugins_dir = "/plugins/"
local launcher = "org.eclipse.equinox.launcher_1.6.500.v20230622-2056.jar"
local workspace_dir = mason_jdtls_dir .. "/workspace/" .. project_name


local is_file_exist = function(path)
  local f = io.open(path, 'r')
  return f ~= nil and io.close(f)
end

-- This was stolen from: https://github.com/baobaoit/beande/blob/development/ftplugin/java.lua
-- Flipping genious
local get_lombok_javaagent = function()
  local lombok_dir = home .. '/.gradle/caches/modules-2/files-2.1/org.projectlombok/lombok/'
  local lombok_versions = io.popen('ls -1 "' .. lombok_dir .. '" | sort -r')
  if lombok_versions ~= nil then
    local lb_i, lb_versions = 0, {}
    for lb_version in lombok_versions:lines() do
      lb_i = lb_i + 1
      lb_versions[lb_i] = lb_version
    end
    lombok_versions:close()
    if next(lb_versions) ~= nil then
      local lombok_jar = vim.fn.expand(string.format('%s%s/*/lombok-%s.jar', lombok_dir, lb_versions[1],  lb_versions[1]))
      if is_file_exist(lombok_jar) then
        return string.format('-javaagent:%s', lombok_jar)
      end
    end
  end
  return ''
end


-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {
  -- cmd = { home .. mason_jdtls_dir .. "/bin/jdtls" },
  cmd = {

    -- 💀
    "java", -- or '/path/to/java17_or_newer/bin/java'
    -- depends on if `java` is in your $PATH env variable and if it points to the right version.

    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xms1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",
    get_lombok_javaagent(),

    -- 💀
    "-jar",
    home .. mason_jdtls_dir .. plugins_dir .. launcher,
    -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
    -- Must point to the                                                     Change this to
    -- eclipse.jdt.ls installation                                           the actual version

    -- 💀
    "-configuration",
    home .. mason_jdtls_dir .. "/config_mac",
    -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
    -- Must point to the                      Change to one of `linux`, `win` or `mac`
    -- eclipse.jdt.ls installation            Depending on your system.

    -- 💀
    -- See `data directory configuration` section in the README
    "-data",
    home .. workspace_dir,
  },

  -- 💀
  -- This is the default if not provided, you can remove it. Or adjust as needed.
  -- One dedicated LSP server & client will be started per unique root_dir
  root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "build.gradle" }),
  -- root_dir = function(fname)
  --   return require("lspconfig").util.root_pattern("pom.xml", "gradle.build", ".git")(fname) or vim.fn.getcwd()
  -- end,
  -- root_dir = function(fname)
  --   return require("lspconfig").util.root_pattern("pom.xml", "gradle.build", ".git")(fname) or vim.fn.getcwd()
  -- end,

  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
    java = {
      -- -- home = '/Users/ivanermolaev/Library/Java/JavaVirtualMachines/temurin-18.0.1/Contents/Home/',
      eclipse = {
        downloadSources = true,
      },
      -- configuration = {
      --   updateBuildConfiguration = "interactive",
      --   -- runtimes = {
      --   --   {
      --   --     name = "JavaSE-17",
      --   --     path = "/Users/ivanermolaev/Library/Java/JavaVirtualMachines/temurin-17.0.4/Contents/Home",
      --   --   }
      --   -- }
      -- },
      -- maven = {
      --   downloadSources = true,
      -- },
      -- implementationsCodeLens = {
      --   enabled = true,
      -- },
      -- referencesCodeLens = {
      --   enabled = true,
      -- },
      references = {
        includeDecompiledSources = true,
      },
      format = {
        enabled = true,
        settings = {
          url = vim.fn.stdpath("config") .. "/lang-servers/intellij-java-google-style.xml",
          profile = "GoogleStyle",
        },
      },
      signatureHelp = { enabled = true },
      completion = {
        favoriteStaticMembers = {
          "org.hamcrest.MatcherAssert.assertThat",
          "org.hamcrest.Matchers.*",
          "org.hamcrest.CoreMatchers.*",
          "org.junit.jupiter.api.Assertions.*",
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
          "org.mockito.Mockito.*",
        },
        importOrder = {
          "java",
          "javax",
          "com",
          "org",
        },
      },
      extendedClientCapabilities = extendedClientCapabilities,
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
      codeGeneration = {
        toString = {
          template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
        },
        useBlocks = true,
      },
    },

    flags = {
      allow_incremental_sync = true,
    },

    -- Language server `initializationOptions`
    -- You need to extend the `bundles` with paths to jar files
    -- if you want to use additional eclipse.jdt.ls plugins.
    --
    -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
    --
    -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
    init_options = {
      bundles = {},
      workspace = {
        -- Lombok plugin configuration
        configuration = {
          ["org.eclipse.jdt.core.compiler.processAnnotations"] = true,
        },
      },
    },
  },
}
-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
-- return config
require("jdtls").start_or_attach(config)
